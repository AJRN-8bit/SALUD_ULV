import type { FastifyReply, FastifyRequest } from "fastify";
import type { IAddMemberUseCase, IGetGroupsList, IGetGroupWithMembersUseCase } from "../../../core/application/repositories/use-cases/group_usecases.ts";
import { GroupDTO } from "../../DTOs/groupDTO.ts";



export const addMemberToGroupController = (useCase: IAddMemberUseCase) => {
  return async (request: FastifyRequest, reply: FastifyReply) => {
    try {
        const {groupID, userUUID} = request.body as any;
        // const groupID = body.groupID;
        // const userUUID = body.userUUID;

      console.log(`In http: ${groupID}`);
      console.log(`In http: ${userUUID}`);
    
      await useCase.execute(groupID, userUUID);

     return reply.status(201).send({
        message: "Member added succesfully to group",
      });

    } catch (error) {
      return reply.status(500).send({
        error: error instanceof Error ? error.message : "Internal Server Error"
      });
    }
  };
};



export const getGroupsListController = (useCase: IGetGroupsList) => {
  return async (request: FastifyRequest, reply: FastifyReply) => {
    try {
      const {memberType} = request.params as {memberType: number};

      console.log(`In http: ${memberType}`);
    
      const result = await useCase.execute(memberType);
      const data = result?.map(item => GroupDTO.fromDomain(item).toJson());
      console.log(result);
      console.log(data);

      if(data == undefined || result == null){
        return reply.status(404).send({
          message: "Could no find group by member type"
        })
      }
      
      return reply.status(200).send({
         data: data,
         message: "Group list",
       });


    } catch (error) {
      return reply.status(500).send({
        error: error instanceof Error ? error.message : "Internal Server Error"
      });
    }
  };
};



// export const getGroupWithMembersController = (useCase: IGetGroupWithMembersUseCase) => {
//   return async (request: FastifyRequest, reply: FastifyReply) => {
//     try {
//       const {groupID} = request.params as {groupID: number};
//       console.log(`In controller groupID: ${groupID}`)
//       // const {userCode} = request.params as {userCode: string};
        
//       const group = await useCase.execute(groupID);

//       const data = GroupDTO.fromDomain(group!).toJson();

//      return reply.status(200).send({
//         message: "Group information with its members",
//         data: data
//       });

//     } catch (error) {
//       return reply.status(500).send({
//         error: error instanceof Error ? error.message : "Internal Server Error"
//       });
//     }
//   };
// };


// export const getAllDepartmentsController = (useCase: IGetAllDepartments) => {
//   return async (request: FastifyRequest, reply: FastifyReply) => {
//     try {
        
//       const result = await useCase.execute();
//       const data = result?.map(item => GroupDTO.fromDomain(item).toJson());

//      return reply.status(200).send({
//         message: "All departments",
//         data: data
//       });

//     } catch (error) {
//       return reply.status(500).send({
//         error: error instanceof Error ? error.message : "Internal Server Error"
//       });
//     }
//   };
// };
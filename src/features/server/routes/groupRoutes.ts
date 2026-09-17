import type { FastifyInstance } from "fastify";
import AddMemberUserCase from "../../../core/application/usecases/group/addMember_use-case.ts";
import GroupRepo from "../../external/mssql/queries/group_repo.ts";
import { addMemberToGroupController, getGroupsListController } from "../controllers/groupController.ts";
import { GetGroupWithMembersUseCase } from "../../../core/application/usecases/group/getGroupWIthMembers_user-case.ts";
import { GetGroupsListUseCase } from "../../../core/application/usecases/group/getGroupList_use-case.ts";



const repository = new GroupRepo;

const addMemberUseCase = new AddMemberUserCase(repository);
const getGroupListUseCase = new GetGroupsListUseCase(repository);
const getGroupWithMembersUseCase = new GetGroupWithMembersUseCase(repository);
const getAllDepartmentsUseCase = new GetGroupsListUseCase(repository);

const addMemberController = addMemberToGroupController(addMemberUseCase);
const getGroupListController = getGroupsListController(getGroupListUseCase);
// const getGroupMembersController = getGroupWithMembersController(getGroupWithMembersUseCase);
// const _getAllDepartamentsController = getAllDepartmentsController(getAllDepartmentsUseCase);


export async function groupRoutes(fastify: FastifyInstance){
    // fastify.get('/get/departments', _getAllDepartamentsController);
    fastify.post('/add', addMemberController);
    fastify.get('/get/:memberType', getGroupListController);
    // fastify.get('/get/members/:groupID', getGroupMembersController);
}
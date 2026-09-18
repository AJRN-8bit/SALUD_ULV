import type { FastifyReply, FastifyRequest } from "fastify";
import type { IAddMemberUseCase, IGetGroupsList } from "../../../core/application/repositories/use-cases/group_usecases.ts";
export declare const addMemberToGroupController: (useCase: IAddMemberUseCase) => (request: FastifyRequest, reply: FastifyReply) => Promise<never>;
export declare const getGroupsListController: (useCase: IGetGroupsList) => (request: FastifyRequest, reply: FastifyReply) => Promise<never>;
//# sourceMappingURL=groupController.d.ts.map
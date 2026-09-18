import type { FastifyRequest, FastifyReply } from 'fastify';
import type { IGetAllDataUseCase, IGetByUserIDUseCase, ISaveAnthroUseCase } from "../../../core/application/repositories/use-cases/anthro_usecases.ts";
export declare const SaveAnthroController: (useCase: ISaveAnthroUseCase) => (request: FastifyRequest, reply: FastifyReply) => Promise<never>;
export declare const GetAllAnthroController: (useCase: IGetAllDataUseCase) => (request: FastifyRequest, reply: FastifyReply) => Promise<never>;
export declare const GetByUserCodeAnthroController: (useCase: IGetByUserIDUseCase) => (request: FastifyRequest, reply: FastifyReply) => Promise<never>;
//# sourceMappingURL=anthropController.d.ts.map
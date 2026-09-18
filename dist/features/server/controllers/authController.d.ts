import type { FastifyRequest, FastifyReply } from 'fastify';
import type { IAuthUseCase } from '../../../core/application/repositories/use-cases/auth_usecases.ts';
export declare const userExistsController: (useCase: IAuthUseCase) => (request: FastifyRequest, reply: FastifyReply) => Promise<never>;
export declare const registerUserController: (useCase: IAuthUseCase) => (request: FastifyRequest, reply: FastifyReply) => Promise<never>;
export declare const loginUserController: (useCase: IAuthUseCase) => (request: FastifyRequest, reply: FastifyReply) => Promise<never>;
export declare const changePasswordController: (useCase: IAuthUseCase) => (request: FastifyRequest, reply: FastifyReply) => Promise<never>;
export declare const deleteAccountController: (useCase: IAuthUseCase) => (request: FastifyRequest, reply: FastifyReply) => Promise<never>;
//# sourceMappingURL=authController.d.ts.map
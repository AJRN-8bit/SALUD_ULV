import { MemberInfo } from "../../../models/member.ts";
import type { User } from "../../../models/user.ts";
import type { IAuthRepo } from "../../repositories/repos/auth_repo.ts";
import type { IHashService } from "../../repositories/services/hashService_repo.ts";
import type { ITokenService } from "../../repositories/services/tokenService_repo.ts";
import type { IAuthUseCase } from "../../repositories/use-cases/auth_usecases.ts";
export default class AuthUseCase implements IAuthUseCase {
    private repository;
    private hashService;
    private tokenService;
    constructor(repository: IAuthRepo, hashService: IHashService, tokenService: ITokenService);
    userExists(userCode: string, email: string): Promise<boolean>;
    registerMember(user: User, password: string, typeID: number): Promise<void>;
    login(input: string, password: string): Promise<string | null>;
    registerMemberInfo(email: string, info: MemberInfo): Promise<void>;
    setMemberType(email: string, typeID: number): Promise<void>;
    changePassword(email: string, newPw: string): Promise<void>;
    deleteAccount(email: string): Promise<void>;
}
//# sourceMappingURL=auth_use-case.d.ts.map
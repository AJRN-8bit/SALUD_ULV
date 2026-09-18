import { User, type IUser } from "../../../../core/models/user.ts";
import type { IAuthRepo } from "../../../../core/application/repositories/repos/auth_repo.ts";
import type { MemberInfo } from "../../../../core/models/member.ts";
export default class AuthRepository implements IAuthRepo {
    registerMember(user: User, password: string): Promise<void>;
    login(input: string): Promise<{
        user: IUser;
        passwordHash: string;
    } | null>;
    setUserRole(userUUID: string): Promise<void>;
    getUserRoles(userUUID: string): Promise<string[] | null>;
    registerMemberInfo(info: MemberInfo): Promise<void>;
    setMemberTypeID(userUUID: string, type: number): Promise<void>;
    getMemberType(userUUID: string): Promise<string | null>;
    getMemberGroupID(userUUID: string): Promise<number | null>;
    findByEmail(email: string): Promise<boolean | null>;
    findByCode(code: string): Promise<boolean | null>;
    changePassword(email: string, newPw: string): Promise<boolean | null>;
    deleteAccount(email: string): Promise<void>;
}
//# sourceMappingURL=userAuth_repo.d.ts.map
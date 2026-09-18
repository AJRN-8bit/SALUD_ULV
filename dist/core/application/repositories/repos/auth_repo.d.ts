import type { MemberInfo } from "../../../models/member.ts";
import type { IUser, User } from "../../../models/user.ts";
export interface IAuthRepo {
    registerMember(user: User, password: string): Promise<void>;
    login(input: string): Promise<{
        user: IUser;
        passwordHash: string;
    } | null>;
    setUserRole(userUUID: string): Promise<void>;
    registerMemberInfo(info: MemberInfo): Promise<void>;
    getUserRoles(userUUID: string): Promise<string[] | null>;
    setMemberTypeID(userUUID: string, type: number): Promise<void>;
    getMemberType(userUUID: string): Promise<string | null>;
    getMemberGroupID(userUUID: string): Promise<number | null>;
    findByEmail(email: string): Promise<boolean | null>;
    findByCode(code: string): Promise<boolean | null>;
    changePassword(email: string, newPw: string): Promise<boolean | null>;
    deleteAccount(email: string): Promise<void>;
}
//# sourceMappingURL=auth_repo.d.ts.map
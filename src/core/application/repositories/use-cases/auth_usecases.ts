import type { MemberInfo } from "../../../models/member.ts";
import { User } from "../../../models/user.ts";

export interface IAuthUseCase{
    userExists(userCode: string, email: string): Promise<boolean>;

    registerMember(user: User, password: string, typeID: number): Promise<void>;
    login(input: string, password: string): Promise<string | null>;

    registerMemberInfo(email: string, info: MemberInfo): Promise<void>;

    setMemberType(email: string, typeID: number): Promise<void>;

    changePassword(email: string, newPw: string): Promise<void>;
    deleteAccount(email: string): Promise<void>;
}
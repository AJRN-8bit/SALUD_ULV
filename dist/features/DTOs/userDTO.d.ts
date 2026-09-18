import { User } from "../../core/models/user.ts";
export declare class UserDTO {
    userUUID: string | undefined;
    userCode: string | undefined;
    firstname: string;
    surname: string;
    lastname: string;
    email: string | undefined;
    createdAt: Date | undefined;
    constructor(data: UserDTO);
    static fromDomain(user: User): UserDTO;
    static fromMap(row: Record<string, any>): UserDTO;
    static fromJson(json: Record<string, any>): UserDTO;
    toDomain(): User;
    toJson(): Record<string, any>;
}
//# sourceMappingURL=userDTO.d.ts.map
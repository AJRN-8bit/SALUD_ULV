import { User } from "../../core/models/user.ts";

export class UserDTO {
    userUUID: string | undefined;
    userCode: string | undefined;
    firstname: string;
    surname: string;
    lastname: string;
    email: string | undefined;
    // roles?: string[];
    createdAt: Date | undefined;

    constructor(data: UserDTO) {
        this.userUUID = data.userUUID;
        this.userCode = data.userCode;
        this.firstname = data.firstname;
        this.surname = data.surname;
        this.lastname = data.lastname;
        this.email = data.email;
        // this.roles = data.roles;
        this.createdAt = data.createdAt;
    }

    // ─── Domain (UserModel) → DTO ───────────────────
    static fromDomain(user: User): UserDTO {
        return new UserDTO({
            userUUID: user.userUUID,
            userCode: user.userCode,
            firstname: user.firstname!,
            surname: user.surname!,
            lastname: user.lastname!,
            email: user.email,
            // roles: user.roles,
            createdAt: user.createdAt,
        } as UserDTO);
    }

    // ─── Database row → DTO ─────────────────────────
    static fromMap(row: Record<string, any>): UserDTO {
        return new UserDTO({
            userUUID: row['UserUUID'],
            userCode: row['UserCode'],
            firstname: row['Firstname'],
            surname: row['Surname'],
            lastname: row['Lastname'],
            email: row['Email'],
            // roles: row['Roles'],
            createdAt: row['CreatedAt']
                ? new Date(row['CreatedAt'])
                : undefined,
        } as UserDTO);
    }


    // ─── JSON (API request body) → DTO ──────────────
    static fromJson(json: Record<string, any>): UserDTO {
        return new UserDTO({
            userUUID: json['userUUID'],
            userCode: json['userCode'],
            firstname: json['firstname'],
            surname: json['surname'],
            lastname: json['lastname'],
            email: json['email'],
            // roles: json['roles'],
            createdAt: json['createdAt']
                ? new Date(json['createdAt'])
                : undefined,
        } as UserDTO);
    }

    // ─── DTO → Domain (UserModel) ───────────────────
    toDomain(): User {
        return new User(
            this.userUUID!,
            this.userCode!,
            this.firstname,
            this.surname,
            this.lastname,
            this.email!,
            // this.roles,
            this.createdAt!,
        );
    }

    // ─── DTO → JSON (API response) ──────────────────
    toJson(): Record<string, any> {
        return {
            userUUID: this.userUUID,
            userCode: this.userCode,
            firstname: this.firstname,
            surname: this.surname,
            lastname: this.lastname,
            email: this.email,
            // roles: this.roles,
            createdAt: this.createdAt?.toISOString(),
        };
    }
}

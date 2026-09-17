
export class RegisterUserDTO {
    readonly userUUID: string;
    readonly email: string
    private password: string;

    constructor(userUUID: string, email: string, password: string) {
        this.userUUID = userUUID;
        this.email = email;
        this.password = password;
    }
}
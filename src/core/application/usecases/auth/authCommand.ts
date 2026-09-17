
export default class AuthCommand {
    private userID: number;
    private email: string;
    private password: string;

    constructor(userID: number, email: string, password: string){
        this.userID = userID;
        this.email = email;
        this.password = password;
    }

    
}
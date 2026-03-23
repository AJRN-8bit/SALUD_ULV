import { User } from "../../domain/user/user.ts";
import type { IUserRegistry, IUserInfoRegistry, IUserLogin } from "../../domain/user/user.ts";
import type IUserRepository from "../../application/ports/userRepository.ts";

export class RegisterUser{ 
    private repository: IUserRepository;
    private user: IUserRegistry;
    constructor(repository: IUserRepository, user: IUserRegistry){
        this.repository = repository;
        this.user = user;
    }

    async execute(): Promise<void>{
        const userID = await User.validateUserID(this.user.userID);
        if(!userID){
            throw new Error("Invalid User ID");
        }

        const email = await User.validateEmail(this.user.email);
        if(!email){
            throw new Error("Invalid email format");
        }

        const password = await User.validatePassword(this.user.password);
        if(!password){
            throw new Error("Password must contain at least 8 characters, one number and one letter");
        }

        const hashedPassword = await User.hashPassword(this.user.password);

        // Hashed password assignation
        this.user.password = hashedPassword;
        
        await this.repository.registerUser(this.user);
            
    }
}


export class RegisterUserInfo{
    private repository: IUserRepository;
    private user: IUserInfoRegistry;
    constructor(repository: IUserRepository, user: IUserInfoRegistry){
        this.repository = repository;
        this.user = user;
    }
    
    async execute(): Promise<void>{
        
        await this.repository.registerUserInfo(this.user);
        
    }
}


export class UserLogin{
    private repository: IUserRepository;
    private user: IUserLogin
    constructor(repository: IUserRepository, user: IUserLogin){
        this.repository = repository;
        this.user = user;
    }

    async execute(): Promise<void>{

        const email = await User.validateEmail(this.user.email);
        if(!email){
            throw new Error("Invalid email format");
        }

        const password = await User.validatePassword(this.user.password);
        if(!password){
            throw new Error("Password must contain at least 8 characters, one number and one letter");
        }

        await this.repository.loginUser(this.user);
    }

}
        
        
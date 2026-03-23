// import {UserAnthropometric} from "../../../domain/user/userAntroph.ts";
import type {IUserAnthropometric} from "../../../domain/user/userAntroph.ts";

import type IUserRepository from "../../../application/ports/userRepository.ts";


export default class RegisterUserAnthropometricData{
    private repository: IUserRepository;
    private userAnthropometric: IUserAnthropometric;

    constructor(repository: IUserRepository, userAnthropometric: IUserAnthropometric){
        this.repository = repository;
        this.userAnthropometric = userAnthropometric;
    }

    async execute(): Promise<void>{
        return await this.repository.registerUserAnthropometricData(this.userAnthropometric);

    }
}
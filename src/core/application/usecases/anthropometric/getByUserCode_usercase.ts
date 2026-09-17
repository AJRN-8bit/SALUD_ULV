import type { Anthropometric } from "../../../models/antropometric.ts";
import type { IAnthroRepo } from "../../repositories/repos/anthro_repo.ts";
import type { IGetAllDataUseCase, IGetByUserIDUseCase } from "../../repositories/use-cases/anthro_usecases.ts";


export class GetByUserIDUseCase implements IGetByUserIDUseCase {
    private repository: IAnthroRepo;

    constructor(repository: IAnthroRepo){
        this.repository = repository;
    }

    async execute(userID: string): Promise<Anthropometric[] | null> {
        const data = await this.repository.getAllByUserCode(userID);
        // console.log(`In usecase: ${data}`);
        if(!data) {return null}

        return data;
    }
}
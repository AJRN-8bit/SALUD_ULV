import type { Anthropometric } from "../../../models/antropometric.ts";
import type { IAnthroRepo } from "../../repositories/repos/anthro_repo.ts";
import type { IGetAllDataUseCase } from "../../repositories/use-cases/anthro_usecases.ts";


export class GetAllAnthroUseCase implements IGetAllDataUseCase {
    private repository: IAnthroRepo;

    constructor(repository: IAnthroRepo){
        this.repository = repository;
    }

    async execute(): Promise<Anthropometric[] | null> {
        const data = await this.repository.getAllData();
        // console.log(`In usecase: ${data}`);
        if(!data) {return null}


        return data;
    }
}
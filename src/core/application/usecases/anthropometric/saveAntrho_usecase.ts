import type { Anthropometric } from "../../../models/antropometric.ts";
import type { IAnthroRepo } from "../../repositories/repos/anthro_repo.ts";
import type { ISaveAnthroUseCase } from "../../repositories/use-cases/anthro_usecases.ts";


export class SaveAnthroUseCase implements ISaveAnthroUseCase{
    private repository: IAnthroRepo;

    constructor(repository: IAnthroRepo){
        this.repository = repository;
    }

    async execute(data: Anthropometric): Promise<void> {
        await this.repository.save(data);
    }
}
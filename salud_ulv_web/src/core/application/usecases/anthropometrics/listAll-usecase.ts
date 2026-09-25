import type { Anthropometric } from "../../../models/anthropometric";
import type { IAnthroRepo } from "../../repos/anthro-repo";
import type { IListAllAnthropometrics } from "../../repos/usecases/anthro-usecases";


export class ListAllAnthropometricsUseCase implements IListAllAnthropometrics{
    private readonly repo: IAnthroRepo;
    
    constructor(repo: IAnthroRepo ){this.repo = repo}

    async execute(): Promise<Anthropometric[] | null>{
        const anthroList = await this.repo.listAll();
        if(anthroList == null) return null;

        return anthroList;
    }
}
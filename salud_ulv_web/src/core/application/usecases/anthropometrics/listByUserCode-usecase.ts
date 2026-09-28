import type { Anthropometric } from "../../../models/anthropometric";
import type { IAnthroRepo } from "../../repos/anthro-repo";
import type { IListAnthroByUserCode } from "../../repos/usecases/anthro-usecases";


export class ListByUserCodeUseCase implements IListAnthroByUserCode {
    private readonly repo: IAnthroRepo;

    constructor(repo: IAnthroRepo) { this.repo = repo }

    async execute(userCode: string): Promise<Anthropometric[] | null> {
        if(userCode == null) return null;

        const data = await this.repo.getAllByUserCode(userCode);
        if(data == null) return null;

        return data;
    }
}
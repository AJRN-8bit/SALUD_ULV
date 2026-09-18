import type { Anthropometric } from "../../../models/antropometric.ts";
import type { IAnthroRepo } from "../../repositories/repos/anthro_repo.ts";
import type { IGetAllDataUseCase } from "../../repositories/use-cases/anthro_usecases.ts";
export declare class GetAllAnthroUseCase implements IGetAllDataUseCase {
    private repository;
    constructor(repository: IAnthroRepo);
    execute(): Promise<Anthropometric[] | null>;
}
//# sourceMappingURL=getAllAnthro_usecase.d.ts.map
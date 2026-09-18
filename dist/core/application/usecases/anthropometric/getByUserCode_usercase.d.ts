import type { Anthropometric } from "../../../models/antropometric.ts";
import type { IAnthroRepo } from "../../repositories/repos/anthro_repo.ts";
import type { IGetByUserIDUseCase } from "../../repositories/use-cases/anthro_usecases.ts";
export declare class GetByUserIDUseCase implements IGetByUserIDUseCase {
    private repository;
    constructor(repository: IAnthroRepo);
    execute(userID: string): Promise<Anthropometric[] | null>;
}
//# sourceMappingURL=getByUserCode_usercase.d.ts.map
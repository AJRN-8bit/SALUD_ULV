import type { Anthropometric } from "../../../models/antropometric.ts";
import type { IAnthroRepo } from "../../repositories/repos/anthro_repo.ts";
import type { ISaveAnthroUseCase } from "../../repositories/use-cases/anthro_usecases.ts";
export declare class SaveAnthroUseCase implements ISaveAnthroUseCase {
    private repository;
    constructor(repository: IAnthroRepo);
    execute(data: Anthropometric): Promise<void>;
}
//# sourceMappingURL=saveAntrho_usecase.d.ts.map
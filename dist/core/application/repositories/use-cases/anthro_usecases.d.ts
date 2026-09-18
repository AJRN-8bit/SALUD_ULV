import type { Anthropometric } from "../../../models/antropometric.ts";
export interface ISaveAnthroUseCase {
    execute(data: Anthropometric): Promise<void>;
}
export interface IGetAllDataUseCase {
    execute(): Promise<Anthropometric[] | null>;
}
export interface IGetByUserIDUseCase {
    execute(userID: string): Promise<Anthropometric[] | null>;
}
//# sourceMappingURL=anthro_usecases.d.ts.map
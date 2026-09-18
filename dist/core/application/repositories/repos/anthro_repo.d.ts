import type { Anthropometric } from "../../../models/antropometric.ts";
export interface IAnthroRepo {
    save(data: Anthropometric): Promise<void>;
    getAllData(): Promise<Anthropometric[] | null>;
    getAllByUserCode(userCode: String): Promise<Anthropometric[] | null>;
    getAllByCodeAndField(userCode: String, field: String): Promise<Anthropometric[] | null>;
}
//# sourceMappingURL=anthro_repo.d.ts.map
import type { IAnthroRepo } from "../../../../core/application/repositories/repos/anthro_repo.ts";
import { Anthropometric } from "../../../../core/models/antropometric.ts";
export default class AnthroRepo implements IAnthroRepo {
    save(data: Anthropometric): Promise<void>;
    getAllData(): Promise<Anthropometric[] | null>;
    getAllByUserCode(userID: String): Promise<Anthropometric[] | null>;
    getAllByCodeAndField(userCode: String, field: String): Promise<Anthropometric[] | null>;
}
//# sourceMappingURL=anthro_repo.d.ts.map
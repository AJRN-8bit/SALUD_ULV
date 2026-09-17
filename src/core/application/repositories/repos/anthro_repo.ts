import type { Anthropometric } from "../../../models/antropometric.ts";
import type { MemberInfo } from "../../../models/member.ts";

export interface IAnthroRepo {
    save(data: Anthropometric): Promise<void>;
    getAllData(): Promise<Anthropometric[] | null>;
    getAllByUserCode(userCode: String): Promise<Anthropometric[] | null>;
    getAllByCodeAndField(userCode: String, field: String): Promise<Anthropometric[] | null>;
}
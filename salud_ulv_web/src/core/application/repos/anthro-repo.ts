import type { Anthropometric } from "../../models/anthropometric";

export interface IAnthroRepo {
    listAll(): Promise<Anthropometric[] | null>;
    getAllByUserCode(userCode: string): Promise<Anthropometric[] | null>;
    getAllByCodeAndField(userCode: string, field: String): Promise<Anthropometric[] | null>;
}
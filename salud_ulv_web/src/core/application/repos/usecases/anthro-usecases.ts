import type { Anthropometric } from "../../../models/anthropometric";


export interface IListAllAnthropometrics {
    execute(): Promise<Anthropometric[] | null>;
}

export interface IListAnthroByUserCode {
    execute(userCode: string): Promise<Anthropometric[] | null>
}
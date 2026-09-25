import type { IAnthroRepo } from "../../core/application/repos/anthro-repo";
import type { Anthropometric } from "../../core/models/anthropometric";

export async function readResponse<T>(res: Response): Promise<T> {
    const data = await res.json();
    if(!res.ok) throw new Error((data as Error).message ?? "Not posible to complete solicitud"); 

    return data as T;
}

const uri = import.meta.env.VITE_API_URI;

export class AnthroRepo implements IAnthroRepo{


    async listAll(): Promise<Anthropometric[] | null> {
        try {
            const response = await fetch(`${uri}/anthro/get/all`, {
                method: "GET"
            })
            const data = await readResponse(response);
            if(!data || data == null) return null;

            console.log(data);

            return (data as any).data as Anthropometric[];

        } catch (error) {
            throw new Error(`${error}`);
        }
    }

    async getAllByCodeAndField(userCode: String, field: String): Promise<Anthropometric[] | null> {
        const hello = userCode;
        const hi = field;
        if(hello == '' || hi == '') return null;
        return null;
    }

    async getAllByUserCode(userCode: string): Promise<Anthropometric[] | null> {
        try {
            const response = await fetch(`${uri}/anthro/get/${encodeURIComponent(userCode)}`, {
                method: "GET"
            })
            const data = await readResponse(response);
            if(!data || data == null) return null;

            console.log(data);

            return (data as any).data as Anthropometric[];

        } catch (error) {
            throw new Error(`${error}`);
        }
    }
} 
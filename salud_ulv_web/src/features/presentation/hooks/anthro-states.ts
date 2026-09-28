// anthro-states.ts
import { useState, useCallback } from "react";
import type { Anthropometric } from "../../../core/models/anthropometric";
import type { IListAllAnthropometrics, IListAnthroByUserCode } from "../../../core/application/repos/usecases/anthro-usecases";

export const anthroHook = () => {
    const [anthroList, setAnthroList] = useState<Anthropometric[] | null>(null);
    const [userList, setUserList] = useState<Anthropometric[] | null>(null);
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState<string | null>(null);

    const loadAll = useCallback(async (usecase: IListAllAnthropometrics) => {
        setLoading(true);
        setAnthroList([]);
        setError(null);
        try {
            const data = await usecase.execute();
            if (data == null) throw new Error('Error al consultar');
            setAnthroList(data);
        } catch (error) {
            setAnthroList(null);
            setError(error instanceof Error ? error.message : "Error inesperado");
        } finally {
            setLoading(false);
        }
    }, []);

    const loadByUserCode = useCallback(async (usecase: IListAnthroByUserCode, userCode: string) => {
        setLoading(true);
        setUserList([]);
        setError(null);
        try {
            const data = await usecase.execute(userCode);
            if (data == null) throw new Error('Datos de usuario no encontrados');
            setUserList(data);
        } catch (error) {
            setUserList(null);
            setError(error instanceof Error ? error.message : "Error inesperado");
        } finally {
            setLoading(false);
        }
    }, []);

    return { anthroList, userList, loading, error, loadAll, loadByUserCode };
};
import { useEffect, useState, type FormEvent } from "react";
import { ListAllAnthropometricsUseCase } from "../../../../core/application/usecases/anthropometrics/listAll-usecase";
import { AnthroRepo } from "../../../services/anthro-services";
import { anthroHook } from "../../hooks/anthro-states";
import { ListByUserCodeUseCase } from "../../../../core/application/usecases/anthropometrics/listByUserCode-usecase";

const listAnthroUseCase = new ListAllAnthropometricsUseCase(new AnthroRepo());
const listAnthroByCodeUseCase = new ListByUserCodeUseCase(new AnthroRepo());

export function ListAnthropometricPage() {
    const { anthroList, userList, loading, error, loadAll, loadByUserCode} = anthroHook();
    const [userCode, setUserCode] = useState("");
    const [isSearching, setIsSearching] = useState(false);

    useEffect(() => {
        loadAll(listAnthroUseCase);
    }, []);

    const searchByUserCode = (event: FormEvent<HTMLFormElement>) => {
        event.preventDefault();

        console.log(`${userCode.trim()}`)

        if (userCode.trim() === "") {
            setIsSearching(false);
            loadAll(listAnthroUseCase);
            return;
        }
        setIsSearching(true);
        loadByUserCode(listAnthroByCodeUseCase, userCode);
    }

    // list condition
    const displayList = isSearching && userList && userList.length > 0 
        ? userList 
        : anthroList;

    return (
        <div>
            <h2>Datos Antropométricos</h2>


            <form onSubmit={searchByUserCode}>
                <input
                    className="input-component"
                    type="text"
                    placeholder="Buscar por matrícula"
                    value={userCode}
                    onChange={(e) => setUserCode(e.target.value)}
                />
                <button className="simple-button" type="submit" disabled={loading}>Buscar</button>
            </form>

            {loading && <p>Getting data...</p>}
            {error && <p>Error:{error}</p>}
            {(!displayList || displayList.length === 0) && !loading && <p>No data available</p>}

            {
                <table className="anthro-table" style={{ margin: "0 auto"}}>
                    <thead>
                        <tr>
                            <th>Matrícula</th>
                            <th>Altura</th>
                            <th>Peso</th>
                            <th>SMM</th>
                            <th>Masa de grasa</th>
                            <th>Porcentaje de grasa</th>
                            <th>IMC</th>
                            <th>ICC</th>
                            <th>Fecha de registro</th>
                        </tr>
                    </thead>
                    <tbody>
                        {displayList?.map((item) => (
                            <tr key={item.anthropometricID}>
                                <td>{item.userCode}</td>
                                <td>{item.height}</td>
                                <td>{item.weight}</td>
                                <td>{item.smm}</td>
                                <td>{item.fatMass}</td>
                                <td>{item.bodyFatPercentage}</td>
                                <td>{item.bmi}</td>
                                <td>{item.whr}</td>
                                <td>{new Date(item.registeredAt).toLocaleDateString()}</td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            }
        </div>
    );
}
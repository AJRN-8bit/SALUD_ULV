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

    useEffect(() => {
        loadAll(listAnthroUseCase);
    }, []);

    const searchByUserCode = (event: FormEvent<HTMLFormElement>) => {
        event.preventDefault();
        if (userCode.trim() === "") return;
        loadByUserCode(listAnthroByCodeUseCase ,userCode);
    }

    // return (
    //     <div>
    //         <p>Anthropometrics</p>

    //         <form onSubmit={handleSubmit}>
    //             <button type="submit" disabled={loading}> Get </button>
    //         </form>

    //         {loading && <p>Getting data...</p>}
    //         {error && <p>Error:{error}</p>}

    //         {anthroList?.map((item, i) => (<p key={i}>{JSON.stringify(item)}</p>))}

    //     </div>
    // );
    // console.log("anthroList:", anthroList, typeof anthroList, Array.isArray(anthroList));
    const displayList = userList && userList.length > 0 ? userList : anthroList;

    return (
        <div>
            <h2>Datos antropométricos</h2>


            <form onSubmit={searchByUserCode}>
                <input
                    type="text"
                    placeholder="Buscar por matrícula"
                    value={userCode}
                    onChange={(e) => setUserCode(e.target.value)}
                />
                <button type="submit" disabled={loading}>Buscar</button>
            </form>

            {loading && <p>Getting data...</p>}
            {error && <p>Error:{error}</p>}
            {(!displayList || displayList.length === 0) && !loading && <p>No data available</p>}

            {
                <table style={{ margin: "0 auto"}}>
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
import { useState } from "react";
import { ListAnthropometricPage } from "./anthropometrics/listAll-screen";

type Page = "home" | "anthropometrics";

function Home() { return <div>Home Page</div>; }

export default function MainWrapper() {
    const [page, setPage] = useState<Page>("home");

    const renderPage = () => {
        switch (page) {
            case "home": return <Home />;
            case "anthropometrics": return <ListAnthropometricPage />;
        }
    };

    return (
        <div style={{ display: "flex", height: "100vh" }}>

            <aside className="side-main-panel">
                <div style={{ display: "flex", flexDirection: "column", gap: 4}}>
                    

                    <button onClick={() => setPage("home")}>Home</button>
                    <button onClick={() => setPage("anthropometrics")}>Antropométricos</button>

                </div>
            </aside>

            <main style={{ flex: 1, padding: 16 }}>
                {renderPage()}
            </main>
        </div>
    );
}
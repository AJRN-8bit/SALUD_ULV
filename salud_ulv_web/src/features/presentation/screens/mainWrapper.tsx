import { useState } from "react";
import { ListAnthropometricPage } from "./anthropometrics/listAll-screen";

type Page = "home" |"anthropometrics" | "profile" | "settings";

function Home() { return <div>Home Page</div>; }
function Profile() { return <div>Profile Page</div>; }
function Settings() { return <div>Settings Page</div>; }

export default function Layout() {
  const [page, setPage] = useState<Page>("home");

  const renderPage = () => {
    switch (page) {
      case "home": return <Home />;
      case "anthropometrics": return <ListAnthropometricPage />;
      case "profile": return <Profile />;
      case "settings": return <Settings />;
    }
  };

 return (
  <div style={{ display: "flex", height: "100vh" }}>
    {/* Side menu stays fixed */}
    <aside style={{ width: 200, borderRight: "1px solid #ddd", padding: 16 }}>
      <div style={{ display: "flex", flexDirection: "column", gap: 8 }}>
        <button onClick={() => setPage("home")}>Home</button>
        <button onClick={() => setPage("anthropometrics")}>Anthropometrics</button>
        {/* <button onClick={() => setPage("profile")}>Profile</button>
        <button onClick={() => setPage("settings")}>Settings</button> */}
      </div>
    </aside>

    {/* Only this part changes */}
    <main style={{ flex: 1, padding: 16 }}>
      {renderPage()}
    </main>
  </div>
);
}
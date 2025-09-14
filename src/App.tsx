import { Header } from "./components/header.tsx";
import { Main } from "./components/main.tsx";
import { Footer } from "./components/footer.tsx";
import "./App.css";

export default function app() {

  return(
    <>
      <Header />
      <Main />
      <Footer />
    </>
  )
}
import { signInWithEmailAndPassword } from "firebase/auth";
import { FormEventHandler, useState } from "react";
import { Link } from "react-router-dom";

// local dependencies
import { useAppCtx } from "../store/store";
import { BackGroundCanvas } from "../components";
import { weblogger } from "../utils";

const Signin: React.FC = () => {
  const { state } = useAppCtx();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");

  const handleSubmit: FormEventHandler<HTMLFormElement> = (e) => {
    e.preventDefault();
    if (!state.auth) {
      weblogger.err("signin", "auth is undefinde");
      return;
    }
    signInWithEmailAndPassword(state.auth, email, password)
      .then(() => {
        weblogger.nomal("signin", "user signin successfully");
        location.href = "#/";
      })
      .catch((err) => weblogger.err("signin", err));
  };

  return (
    <div className="font-semibold bg-NRyellow/80 w-screen h-screen">
      <BackGroundCanvas></BackGroundCanvas>
      <form onSubmit={handleSubmit}>
        <label>
          <div>邮箱</div>
          <input
            type="email"
            value={email}
            onChange={(e) => setEmail(e.currentTarget.value)}
            className=" bg-gray-500 "
          />
        </label>
        <label>
          <div>密码</div>
          <input
            type="password"
            value={password}
            onChange={(e) => setPassword(e.currentTarget.value)}
            className=" bg-gray-500 "
          />
        </label>
        <button type="submit">Sign In</button>
      </form>
      <Link to="signup">{"加入YoRHa部队(注册)"}</Link>
    </div>
  );
};

export default Signin;

import 'bootstrap/dist/css/bootstrap.min.css'
import { useEffect, useState } from 'react';
import { BrowserRouter, Switch, Route } from 'react-router-dom';
import './App.css';
import NavBar from './components/NavBar';
import ProtectedRoute from './components/router/ProtectedRoute';
import { loginContext } from './contexts/loginContext';
import { checkAuthSession } from './helpers/BackendAuthHelpers';
import LoginPage from './screens/auth/LoginPage';
import SignUp from './screens/auth/SignUp';
import HomePage from './screens/home/HomePage';

function App() {

  const [isLoggedIn, setIsLoggedIn] = useState(null)

  useEffect(() => {
    async function checkAuthSessionInHook() { var res = await checkAuthSession(); setIsLoggedIn(res) }
    checkAuthSessionInHook();
  }, [])

  return <>
    <BrowserRouter>
      <loginContext.Provider value={{ isLoggedIn, setIsLoggedIn }}>
        <NavBar />
        <Switch>
          <ProtectedRoute exact path='/' component={HomePage} />
          <Route exact path='/login' component={LoginPage} />
          <Route exact path='/signup' component={SignUp} />
        </Switch>
      </loginContext.Provider>
    </BrowserRouter>
  </>
}

export default App;

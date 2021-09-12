import { useEffect, useState } from 'react';
import { BrowserRouter, Route, Switch } from 'react-router-dom';
import './App.css';
import Navbar from './components/Navbar';
import ProtectedRoute from './components/ProtectedRoute';
import { loginContext } from './contexts/LoginContext';
import { checkAuthSession } from './helpers/BackendAuthHelper';
import LoginPage from './pages/auth/LoginPage';
import HomePage from './pages/home/HomePage';
import 'bootstrap/dist/css/bootstrap.css'
import AllOrdersPage from './pages/order/AllOrdersPage';
import ProfilePage from './pages/profile/ProfilePage';
import RegisterSubdealerPage from './pages/auth/RegisterSubdealerPage';
import 'react-toastify/dist/ReactToastify.css';
import { ToastContainer } from 'react-toastify';
import { orderContext } from './contexts/OrderContext';
import { profileContext } from './contexts/ProfileContext';
import OrderSlugPage from './pages/order/OrderSlugPage';
import SubdealerProductsPage from './pages/products/SubdealerProductsPage';
import StaffSlugPage from './pages/profile/StaffSlugPage';
import CoSubdealerSlugPage from './pages/profile/CoSubdealerSlugPage';
import ServerErrorPage from './pages/error/ServerErrorPage';


function App() {

  const [isLoggedIn, setisLoggedIn] = useState(null)
  const [orders, setOrders] = useState(null)
  const [profile, setProfile] = useState(null)

  useEffect(() => {
    const checkBackend = async () => {
      const res = await checkAuthSession();
      setisLoggedIn(res);
    }
    checkBackend()
  }, [])


  if (isLoggedIn === null) {
    return <center className='m-5 pt-5'>
      <div className="spinner-border text-primary" role="status">
      </div><br /><span className="sr-only pt-4">Loading...</span>
    </center>
  }


  return <loginContext.Provider value={{ isLoggedIn, setisLoggedIn }}>
      <orderContext.Provider value={{ orders, setOrders }}>
        <profileContext.Provider value={{ profile, setProfile }}>
          <ToastContainer />
          <BrowserRouter>
            <Navbar />
            <Switch>
              <ProtectedRoute exact path='/' component={HomePage} />
              <ProtectedRoute exact path='/orders' component={AllOrdersPage} />
              <ProtectedRoute exact path='/orders/:id' component={OrderSlugPage} />
              <Route exact path='/login' component={LoginPage} />
              <Route exact path='/register' component={RegisterSubdealerPage} />
              <Route exact path='/error' component={ServerErrorPage} />
              <ProtectedRoute exact path='/profile' component={ProfilePage} />
              <ProtectedRoute exact path='/products' component={SubdealerProductsPage} />
              <ProtectedRoute exact path='/profile/staff/:id' component={StaffSlugPage} />
              <ProtectedRoute exact path='/profile/co_subdealer/:id' component={CoSubdealerSlugPage} />
            </Switch>
          </BrowserRouter>
        </profileContext.Provider>
      </orderContext.Provider>
    </loginContext.Provider>
}

export default App;

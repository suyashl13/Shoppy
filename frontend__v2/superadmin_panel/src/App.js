import { useEffect, useState } from 'react';
import { BrowserRouter, Switch, Route } from 'react-router-dom';
import './App.css';
import Navbar from './components/Navbar';
import ProtectedRoute from './components/router_components/ProtectedRoute';
import { LoginContext } from './contexts/AuthContext';
import { checkAuthAtBackend } from './helpers/BackendAuthHelper';
import LoginPage from './screens/auth/LoginPage';
import HomePage from './screens/HomePage';

import 'bootstrap/dist/css/bootstrap.css'
import 'react-toastify/dist/ReactToastify.css';
import { ToastContainer } from 'react-toastify';
import { SubdealerContext } from './contexts/SubdealerContext';
import { OrderContext } from './contexts/OrderContext';
import SubdealerPage from './screens/subdealer/SubdealerPage';
import ProductPage from './screens/product_and_category/ProductPage';
import SubdealerSlugPage from './screens/subdealer/SubdealerSlugPage';
import { ProductContext } from './contexts/ProductContext';
import ProductSlugPage from './screens/product_and_category/ProductSlugPage';
import OrderDetailPage from './screens/order/OrderDetailPage';
import { UserContext } from './contexts/UserContext';
import AllUserPage from './screens/user/AllUserPage';
import RedirectToSubdealer from './components/router_components/RedirectToSubdealer';
import UserSlugPage from './screens/user/UserSlugPage';
import PageNotFoundPage from './screens/error/PageNotFoundPage';

function App() {

  const [isLoggedIn, setIsLoggedIn] = useState(null)
  const [subdealerList, setSubdealerList] = useState(null)
  const [orderList, setOrderList] = useState(null)
  const [productAndCategoryList, setProductAndCategoryList] = useState(null)
  const [userList, setUserList] = useState(null)

  useEffect(() => {
    checkAuthAtBackend({
      onSuccess: (res) => {
        setIsLoggedIn(res)
      }, onError: (err) => { }
    })
  }, [])

  if (isLoggedIn === null) {
    return <center>
      <div className="spinner-border m-5" role="status">
        <span className="visually-hidden">Loading...</span>
      </div>
    </center>
  } else {
    return (
      <BrowserRouter>
        <ToastContainer />
        <LoginContext.Provider value={{ isLoggedIn, setIsLoggedIn }}>
          <SubdealerContext.Provider value={{ subdealerList, setSubdealerList }}>
            <OrderContext.Provider value={{ orderList, setOrderList }}>
              <ProductContext.Provider value={{ productAndCategoryList, setProductAndCategoryList }}>
                <UserContext.Provider value={{ userList, setUserList }}>

                  {/* Router */}
                  <>
                    <Navbar />
                    <Switch>
                      <ProtectedRoute path='/' component={HomePage} exact />
                      <ProtectedRoute exact path='/users' component={AllUserPage} />
                      <ProtectedRoute exact path='/subdealers' component={SubdealerPage} />
                      <ProtectedRoute exact path='/products' component={ProductPage} />
                      <ProtectedRoute exact path='/subdealer/:subdealer_id' component={SubdealerSlugPage} />
                      <ProtectedRoute exact path='/products/:product_id' component={ProductSlugPage} />
                      <ProtectedRoute exact path='/orders/:order_id' component={OrderDetailPage} />
                      <ProtectedRoute exact path='/redirectsubdealerbyuid/:redirect_user_id' component={RedirectToSubdealer} />
                      <ProtectedRoute exact path='/users/:user_id' component={UserSlugPage} />
                      <Route path='/login' exact component={LoginPage} />
                      <Route component={PageNotFoundPage} />
                    </Switch>
                  </>
                  {/* End Router */}

                </UserContext.Provider>
              </ProductContext.Provider>
            </OrderContext.Provider>
          </SubdealerContext.Provider>
        </LoginContext.Provider>
      </BrowserRouter>
    );
  }
}

export default App;

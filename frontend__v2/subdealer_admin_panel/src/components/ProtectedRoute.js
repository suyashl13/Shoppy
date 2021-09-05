import React, { useContext, useEffect, useState } from 'react'
import { Redirect, Route, useHistory } from 'react-router-dom'
import { toast } from 'react-toastify';
import { loginContext } from '../contexts/LoginContext'
import { orderContext } from '../contexts/OrderContext';
import { getDeliveralbleOrders } from '../helpers/BackendCartHelper';
import ProfilePage from '../pages/profile/ProfilePage';

export default function ProtectedRoute({ component: Component, ...rest }) {

    const { isLoggedIn, } = useContext(loginContext);
    const { orders, setOrders } = useContext(orderContext);
    const [isActive, setisActive] = useState(true)
    const history = useHistory()

    const setOrdersToContext = async () => {
        getDeliveralbleOrders({
            onSuccess: (data) => {
                setOrders(data)
            },
            onError: (error) => {
                if (error.response.data.ERR === 'subdealer deactivated') {
                    setisActive(false)
                    history.push('/profile')
                }
            }
        })
    }

    useEffect(() => {
        if (isLoggedIn === true) {
            if (!orders) {
                if (isActive === false) {
                    history.push('/profile')
                }
                setOrdersToContext();
            }
        }
    }, [])

    return (
        <>
            <Route
                {...rest}
                render={
                    () => {
                        if (isLoggedIn === true) {
                            if (isActive === false) {
                                return <ProfilePage/>
                            }
                            return <Component />
                        } else if (isLoggedIn === false) {
                            return <Redirect to='/login' />
                        }
                    }
                }
            />
        </>
    )
}

import React, { useContext, useEffect, useState } from 'react'
import { Redirect, Route, useHistory } from 'react-router-dom'
import { loginContext } from '../contexts/LoginContext'
import { orderContext } from '../contexts/OrderContext';
import { profileContext } from '../contexts/ProfileContext';
import { getDeliveralbleOrders } from '../helpers/BackendCartHelper';
import { getSubdealerProfile } from '../helpers/BackendProfileHelper';
import ProfilePage from '../pages/profile/ProfilePage';

export default function ProtectedRoute({ component: Component, ...rest }) {

    const { isLoggedIn, } = useContext(loginContext);
    const { orders, setOrders } = useContext(orderContext);
    const { profile, setProfile } = useContext(profileContext)
    const [isActive, setisActive] = useState(true)
    const [isLoading, setisLoading] = useState(true)
    const history = useHistory()

    const setOrdersToContext = async () => {
        getDeliveralbleOrders({
            onSuccess: (data) => {
                setOrders(data)
                setisLoading(false)
            },
            onError: (error) => {
                if (error.response.data.ERR === 'subdealer deactivated') {
                    setisActive(false)
                    setisLoading(false)
                    history.push('/profile')
                }
            }
        })
    }

    const setProfileToContext = async () => {
        getSubdealerProfile({
            onSuccess: (e) => {
                setProfile(e)
            },
            onError: (e) => {
                setisActive(false)
                history.push('/error');
            }
        })
    }

    useEffect(() => {
        if (isLoggedIn === true) {
            if (!profile) { setProfileToContext() }

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

                        if (isLoading) {
                            return <center className='m-5 pt-5'>
                                <div className="spinner-border text-primary" role="status">
                                </div><br /><span className="sr-only pt-4">Loading...</span>
                            </center>
                        } else if (isLoggedIn === true) {
                            if (isActive === false) {
                                return <ProfilePage />
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

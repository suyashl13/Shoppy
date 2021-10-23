import React, { useContext, useEffect, useState } from 'react'
import { Redirect, Route } from 'react-router'
import { toast } from 'react-toastify'
import { LoginContext } from '../../contexts/AuthContext'
import { OrderContext } from '../../contexts/OrderContext'
import { ProductContext } from '../../contexts/ProductContext'
import { SubdealerContext } from '../../contexts/SubdealerContext'
import { getOrderData } from '../../helpers/BackendCartHelper'
import { getProductsAndCategories } from '../../helpers/BackendProductAndCategoryHelper'
import { getSubdealerData } from '../../helpers/BackendSubdealerHelper'

export default function ProtectedRoute({ component: Component, ...rest }) {

    const { isLoggedIn } = useContext(LoginContext)
    const { subdealerList, setSubdealerList } = useContext(SubdealerContext)
    const { orderList, setOrderList } = useContext(OrderContext)
    const { productAndCategoryList, setProductAndCategoryList } = useContext(ProductContext)
    const [isLoading, setIsLoading] = useState(true)

    const getApplicationData = () => {
        setIsLoading(true)
        if (!subdealerList) {
            getSubdealerData({
                onSuccess: ({ data }) => {
                    setSubdealerList(data)
                },
                onError: (err) => { toast('Something went wrong.', { type: 'error' }) }
            })
        }
        if (!orderList) {
            getOrderData({
                onSuccess: ({ data }) => {
                    setOrderList(data)
                },
                onError: (err) => { toast('Something went wrong.', { type: 'error' }) }
            })
        }
        if (!productAndCategoryList) {
            getProductsAndCategories({
                onSuccess: ({ data }) => {
                    setProductAndCategoryList(data);
                },
                onError: (err) => { 
                    console.log({err})
                    toast('Something went wrong.', { type: 'error' }) }
            })
        }
        setIsLoading(false)
    }

    useEffect(() => {
        getApplicationData();
    }, [])

    return <Route
        {...rest}
        render={() => {
            if (isLoading) {
                return <>Loading</>
            }
            if (isLoggedIn) {
                return <Component />
            } else {
                return <Redirect to='/login' />
            }
        }}
    />
}
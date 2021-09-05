import React, { useContext, useState } from 'react'
import { toast } from 'react-toastify';
import { loginContext } from '../../contexts/LoginContext'
import { orderContext } from '../../contexts/OrderContext';
import { loginAtBackend } from '../../helpers/BackendAuthHelper'
import { getDeliveralbleOrders } from '../../helpers/BackendCartHelper';

export default function LoginPage({ history }) {

    const { isLoggedIn, setisLoggedIn } = useContext(loginContext);
    const { setOrders } = useContext(orderContext)
    const [credentials, setCredentials] = useState({ phone: '', password: '' })


    if (isLoggedIn === true) {
        history.push('/')
    }


    const _performLogin = async ({ phone, password }) => {

        if (phone.length !== 10) {
            toast('Phone no. must be 10 digit valid number.')
            return;
        }

        await loginAtBackend({
            phone: phone,
            password: password,
            onSuccess: async () => {
                setisLoggedIn(true)
                history.push('/')
                toast('Logged in Successfully.', { type: 'success' })

                await getDeliveralbleOrders({
                    onSuccess: (data) => {
                        setOrders(data);
                    },
                    onError: (error) => {
                        console.log({ error })
                    }
                })

            },
            onError: (e) => {
                if (e.err.response.data.ERR) {
                    toast(e.err.response.data?.ERR, { type: 'error' });    
                } else toast("Something went wrong.", { type: 'error' });
            }
        })
    }

    return (
        <div className='container mb-5 mt-5'>
            <div className='p-4'>
                <center><h3>
                    {'Login to Subdealer Administration'.toUpperCase()}
                </h3></center>

                <form className='p-4 mt-5' onSubmit={e => {
                    e.preventDefault()
                    _performLogin(credentials);
                }}>
                    <div className="mb-3">
                        <label htmlFor="phone-input" className="form-label">Phone Number</label>
                        <input type="number" value={credentials.phone} onChange={(e) => { setCredentials({ ...credentials, phone: e.target.value }) }} className="form-control" id="phone-input" aria-describedby="emailHelp" maxLength='10' required />
                        <div id="emailHelp" className="form-text">We'll never share your phone with anyone else.</div>
                    </div>
                    <div className="mb-3">
                        <label htmlFor="password-input" className="form-label">Password</label>
                        <input type="password" value={credentials.password} onChange={(e) => { setCredentials({ ...credentials, password: e.target.value }) }} className="form-control" id="password-input" required />
                    </div>
                    <button type="submit" className="btn btn-primary mt-3">Submit</button>
                </form>
            </div>
        </div>
    )
}

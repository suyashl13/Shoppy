import React, { useContext, useState } from 'react'
import { useHistory } from 'react-router'
import { toast } from 'react-toastify'
import { loginContext } from '../../contexts/loginContext'
import { createAccountAtBackend } from '../../helpers/BackendAuthHelpers'

export default function SignUp() {

    const history = useHistory()
    const { setIsLoggedIn } = useContext(loginContext)

    const [accountData, setAccountData] = useState({
        name: '',
        phone: '',
        pincode: '',
        email: '',
        address: '',
        conf_password: '',
        password: '',
    })


    const createAccount = async () => {
        // TODO: Impose Validations


        await createAccountAtBackend({
            onSuccess: (data) => {
                setIsLoggedIn(true);
                history.push('/');
            },
            onError: (err) => {
                console.log(err)
                toast("Opps! Something went wrong.", { type: "error" })
            },
        }, accountData)
    }

    return (
        <div className='container'>
            <div className="card mt-5 p-4 rounded">
                <h3 className='text-dark'>Create an Account</h3>
                <hr />
                <form onSubmit={async e => {
                    e.preventDefault()
                    await createAccount();
                }}>
                    <div className="row">
                        <div className="col-12"><input required type="text" placeholder='Full Name'
                            value={accountData.name}
                            onChange={e => { setAccountData({ ...accountData, name: e.target.value }) }}
                            className="form-control" /></div>
                    </div>
                    <div className="row mt-2">
                        <div className="col-8">
                            <input required type="number" placeholder='Phone no.'
                                value={accountData.phone}
                                onChange={e => { setAccountData({ ...accountData, phone: e.target.value }) }}
                                className="form-control" />
                        </div>
                        <div className="col-4">
                            <input required type="number"
                                value={accountData.pincode}
                                onChange={e => { setAccountData({ ...accountData, pincode: e.target.value }) }}
                                placeholder='Pincode' className="form-control" maxLength='6' />
                        </div>
                    </div>
                    <div className="row mt-2">
                        <div className="col-6">
                            <input required type="password"
                                value={accountData.password}
                                onChange={e => { setAccountData({ ...accountData, password: e.target.value }) }}
                                placeholder='Password' className="form-control" maxLength='12' />
                        </div>
                        <div className="col-6">
                            <input required type="password"
                                value={accountData.conf_password}
                                onChange={e => { setAccountData({ ...accountData, conf_password: e.target.value }) }}
                                placeholder='Confirm Password' className="form-control" maxLength='12' />
                        </div>
                    </div>
                    <input required type="email" placeholder='Email'
                        value={accountData.email}
                        onChange={e => { setAccountData({ ...accountData, email: e.target.value }) }}
                        className="form-control mt-2" />
                    <textarea placeholder='Address'
                        value={accountData.address}
                        onChange={e => { setAccountData({ ...accountData, address: e.target.value }) }}
                        cols="10" rows="2" className="form-control mt-2"></textarea>
                    <button type='submit' className='btn btn-dark mt-4'>Create an Account</button>
                </form>
            </div>
        </div>
    )
}

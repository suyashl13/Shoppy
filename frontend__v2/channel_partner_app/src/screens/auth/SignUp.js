import React from 'react'

export default function SignUp() {
    return (
        <div className='container'>
            <div className="card mt-5 p-4 rounded">
                <h3 className='text-dark'>Create an Account</h3>
                <hr />
                <form>
                    <div className="row">
                        <div className="col-6"><input type="text" placeholder='First Name' id="" className="form-control" /></div>
                        <div className="col-6"><input type="text" placeholder='Last Name' id="" className="form-control" /></div>
                    </div>
                    <div className="row mt-2">
                        <div className="col-8">
                            <input type="number" placeholder='Phone no.' id="" className="form-control" />
                        </div>
                        <div className="col-4">
                            <input type="number" placeholder='Pincode' id="" className="form-control" maxLength='6' max='6' />
                        </div>
                    </div>
                    <input type="email" placeholder='Email' id="" className="form-control mt-2" />
                    <textarea placeholder='Address' id="" cols="10" rows="2" className="form-control mt-2"></textarea>
                    <button type='button' className='btn btn-dark mt-4'>Create an Account</button>
                </form>
            </div>
        </div>
    )
}

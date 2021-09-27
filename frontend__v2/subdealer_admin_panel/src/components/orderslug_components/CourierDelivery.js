import React, { useState } from 'react'
import { toast } from 'react-toastify';
import { assignDeliveryToCourierAtBackend } from '../../helpers/BackendCartHelper'

export default function CourierDelivery(props) {

    const [courierData, setCourierData] = useState({
        courier_name: '',
        courier_tracking_id: '',
    })

    const assignToCourier = async (orderData) => {
        await assignDeliveryToCourierAtBackend(props?.cartId, orderData, {
            onSuccess: (res) => {
                console.log(res)
            }, onError: (err) => {
                if (err?.err.response.data.ERR) {
                    toast(err?.err.response.data.ERR, {type: 'error'})
                } else {
                    toast("Something went wrong.", {type: 'error'})
                }
            }
        });
    }


    return (
        <div className='card'>
            <div className="card-header bg-primary text-light">
                Assign Delivery to Courier Service
            </div>
            <div className="card-body">
                <form onSubmit={async (e) => {
                    e.preventDefault();
                    await assignToCourier(courierData);
                }}>
                    <input type="text" value={courierData.courier_name} onChange={e=>{setCourierData({...courierData, courier_name: e.target.value})}} placeholder='Courier Service Name' id="" className="form-control mb-2" />
                    <input type="text" value={courierData.courier_tracking_id} onChange={e=>{setCourierData({...setCourierData, courier_tracking_id: e.target.value})}} placeholder='Tracking ID' id="" className="form-control mb-2" />
                    <button type="submit" className="btn btn-primary btn-sm">Submit</button>
                </form>
            </div>
        </div>
    )
}

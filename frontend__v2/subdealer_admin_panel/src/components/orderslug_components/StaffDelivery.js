import React, { useContext } from 'react'
import { toast } from 'react-toastify';
import { orderContext } from '../../contexts/OrderContext';
import { profileContext } from '../../contexts/ProfileContext'
import { assignDeliveryToStaffAtBackend } from '../../helpers/BackendCartHelper';

export default function StaffDelivery(props) {

    const { profile } = useContext(profileContext)

    const { orders, setOrders } = useContext(orderContext)
    const staff_users = profile?.staff.map((staff, index) => {
        return {
            id: staff.id,
            name: staff.name,
            phone: staff.phone,
        }
    });



    const assignDelivery = async () => {
        const activeStaffId = document.getElementById('staff-selection').value.split(' - ')[0]
        await assignDeliveryToStaffAtBackend(props.cartId, { assigned_to: activeStaffId }, {
            onSuccess: (data) => {
                const updatedOrders = orders.map(element => {
                    if (element.id == props.cartId) {
                        return data
                    } else {
                        return element
                    }
                });
                setOrders(updatedOrders)
            },
            onError: (err) => {
                toast('Unable to assign an order to staff.', { type: 'error' })
            }
        })
    }

    return (
        <div className='card'>
            <div className="card-header bg-primary text-light">Assign Delivery to Staff Member</div>
            <div className="card-body">
                <div className="form-group">
                    <label htmlFor="staff-selection">Select Staff to Deliver Parcel</label>
                    <select className="form-control" id="staff-selection">
                        {staff_users.map((val, index) => <option key={index}>{val.id} - {val.name} ({val.phone})</option>)}
                    </select>
                    <button
                        onClick={e => { assignDelivery() }}
                        className='mt-3 btn btn-primary btn-sm'>Assign Delivery</button>
                </div>
            </div>
        </div>
    )
}

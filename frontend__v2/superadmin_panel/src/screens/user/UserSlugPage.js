import React, { useContext } from 'react'
import { IoMdCalendar, IoMdCall, IoMdMail, IoMdPerson, IoMdPin } from 'react-icons/io'
import { useParams } from 'react-router'
import { Link } from 'react-router-dom'
import { UserContext } from '../../contexts/UserContext'

export default function UserSlugPage() {

    const { user_id } = useParams()
    const { userList } = useContext(UserContext)
    const kUser = userList?.filter((e) => { return user_id == e.id })[0]

    function getRole(user) {
        if (user?.is_subdealer) {
            return "Subdealer"
        } else if (user?.is_admin_subdealer) {
            return "Admin Subdealer"
        } else if (user?.is_subdealer_staff) {
            return "Staff"
        } else if (user?.is_channel_partner) {
            return "Channel Partner"
        } else {
            return "Customer"
        }
    }

    return (
        <div className='container mt-5'>
            <h3>{kUser?.name} (#{kUser?.id})</h3>
            <hr />
            <div className='text-muted'>
                <IoMdPin />  Address : {kUser?.address} <br />
                <IoMdMail /> Email : {kUser?.email} <br />
                <IoMdCall /> Phone : {kUser?.phone} <br />
                <IoMdPerson /> Role : {getRole(kUser)} <br />
                <IoMdCalendar /> Date Joined : {kUser?.date_time_created.split('.')[0].split('T')[0]}
            </div>
            <br />
            {
                getRole(kUser) === 'Customer' ? <>
                    <h3>Orders</h3>
                    <hr />
                    {   kUser?.carts.length === 0 ? <div className='m-5 d-flex justify-content-center text-muted'>
                        <h4>No Orders.</h4>
                    </div> : null }
                    <ul className='list-group mt-2'>
                        {
                            kUser?.carts.map((element, index) => <CustomerOrderTile order={element} key={index} />)
                        }
                    </ul></> : null
            }
        </div>
    )
}


const CustomerOrderTile = ({ order }) => <li className='list-group-item d-flex justify-content-between'>
    <div>
        <h6 className='mb-2'>{order?.date_time_created.split('.')[0].split('T')[0]}</h6>
        <span className="text-muted">Subtotal : Rs.{order?.subtotal}</span>
    </div>
    <Link to={`/orders/${order?.id}`} className='text-decoration-none'>See Details</Link>
</li>

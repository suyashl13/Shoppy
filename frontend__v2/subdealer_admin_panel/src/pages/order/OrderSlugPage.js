import React, { useContext } from 'react'
import { Redirect, useParams } from 'react-router-dom'
import { orderContext } from '../../contexts/OrderContext';
import { tConvert } from '../../helpers/DateTimeHelper'

export default function OrderSlugPage(props) {

    const { id } = useParams();
    const { orders } = useContext(orderContext)


    if (!orders) {
        return <Redirect to={{ pathname: '/' }} />
    }

    return (
        <div className='container mt-5'>
            <div className="row justify-content-center">
                <div className="col-sm-12 col-md-10 col-lg-10">
                    <div className="card">
                        <div className="card-header">
                            <h3>#{orders[id]?.id} Order Details</h3>
                        </div>
                        <div className="card-body">
                            <table className="table table-bordered">
                                <thead>
                                    <tr>
                                        <th scope="col">Attribute</th>
                                        <th scope="col">Value</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>Name</td>
                                        <td>{orders[id]?.user.name}</td>
                                    </tr>
                                    <tr>
                                        <td>Address</td>
                                        <td>{orders[id]?.shipping_address} ({orders[id]?.pin_code})</td>
                                    </tr>
                                    <tr>
                                        <td>Phone No.</td>
                                        <td>{orders[id]?.delivery_phone}</td>
                                    </tr>
                                    <tr>
                                        <td>Subtotal</td>
                                        <td>Rs. {orders[id]?.subtotal}</td>
                                    </tr>

                                    <tr>
                                        <td>Order Status</td>
                                        <td>{orders[id]?.order_status}</td>
                                    </tr>
                                    <tr>
                                        <td>Is Delivered</td>
                                        <td>{orders[id]?.is_delivered ? 'Yes' : 'No'}</td>
                                    </tr>
                                    <tr>
                                        <td>Is Canceled</td>
                                        <td>{orders[id]?.is_canceled ? 'Yes' : 'No'}</td>
                                    </tr>
                                    <tr>
                                        <td>Is Verified</td>
                                        <td>{orders[id]?.is_verified ? 'Yes' : 'No'}</td>
                                    </tr>
                                    <tr>
                                        <td>Ordered Date-Time</td>
                                        <td>{tConvert(orders[id]?.date_time_created.split('+')[0].split('T')[1].split('.')[0])} ({tConvert(orders[id]?.date_time_created.split('+')[0].split('T')[0])})</td>

                                    </tr>
                                </tbody>
                            </table>
                            <br />
                            <h4 className='mb-3'>Cart Items</h4>
                            <ul className="list-group">
                                {
                                    orders[id]?.cart_items.map((e, i) => <li key={i} className="list-group-item d-flex justify-content-between align-items-center">
                                        <div>
                                            <span style={{ fontSize: '18px' }}>{e.product.title} ({e.product.category}) </span> <br />
                                            <div style={{
                                                color: 'gray',
                                                marginTop: '4px'
                                            }}>
                                                Amount : {e.amount} <br />
                                                Quantity : {e.quantity}
                                            </div>
                                        </div>
                                        <span className="badge bg-success">₹ {e.amount}</span>
                                    </li>
                                    )
                                }
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    )
}

import React, { useContext, useState } from 'react'
import { useParams } from 'react-router'
import { SubdealerContext } from '../../contexts/SubdealerContext'
import { IoMdCalendar, IoMdCall, IoMdCheckmark, IoMdLocate, IoMdMail, IoMdPerson, IoMdSwitch } from 'react-icons/io';
import SubdealerProducts from '../../components/subdealer/slug/SubdealerProducts';
import SubdealerStaff from '../../components/subdealer/slug/SubdealerStaff';
import SubdealerOrders from '../../components/subdealer/slug/SubdealerOrders';
import { updateSubdealerAtBackend } from '../../helpers/BackendSubdealerHelper';
import { toast } from 'react-toastify';

export default function SubdealerSlugPage() {

    const { subdealer_id } = useParams()
    const { subdealerList, setSubdealerList } = useContext(SubdealerContext)

    const kSubdealer = subdealerList?.filter(ele => ele.id == subdealer_id)[0];

    const [activeTab, setActiveTab] = useState('products')

    return (
        <div className='container mt-5'>
            <h2>{kSubdealer?.user.name} ({kSubdealer?.subdealer_code})</h2> ({kSubdealer?.is_active ? "Active" : 'Inactive'})
            <div className="mt-2">
                <IoMdCall /> Phone : {kSubdealer?.user.phone} <br />
                <IoMdMail /> Email : {kSubdealer?.user.email} <br />
                <IoMdLocate /> Address : {kSubdealer?.user.address} <br />
                <IoMdCalendar /> Date Joined : {kSubdealer?.user.date_time_created.split('T')[0]} <br />
                <EditSubdealerForm subdealer={kSubdealer} setSubdealerList={setSubdealerList} subdealerList={subdealerList} />
            </div>
            <hr />
            <ul className="nav nav-pills nav-fill">
                <li className="nav-item">
                    <button className={activeTab != 'products' ? "nav-link" : 'nav-link active'} onClick={() => { setActiveTab('products') }}>Products</button>
                </li>
                <li className="nav-item">
                    <button className={activeTab != 'orders' ? "nav-link" : 'nav-link active'} onClick={() => { setActiveTab('orders') }}>Orders</button>
                </li>
                <li className="nav-item">
                    <button className={activeTab != 'staff' ? "nav-link" : 'nav-link active'} onClick={() => { setActiveTab('staff') }}>Staff</button>
                </li>
            </ul>
            <hr />
            {
                activeTab == '' ? <></> :
                    activeTab == 'products' ? <SubdealerProducts products={kSubdealer?.products} /> :
                        activeTab == 'orders' ? <SubdealerOrders orders={kSubdealer?.carts} /> :
                            activeTab == 'staff' ? <SubdealerStaff staff={kSubdealer?.staff} /> : null
            }
        </div>
    )
}

const EditSubdealerForm = ({ subdealer, setSubdealerList, subdealerList }) => {

    const [isLoading, setisLoading] = useState(false)

    const updateSubdealer = async (updateObject) => {
        await updateSubdealerAtBackend(subdealer?.id, updateObject, {
            onSuccess: ({ data }) => {
                const updatedList = subdealerList?.map((element) => {
                    if (element.id == data.id) {
                        return data;
                    } else {
                        return element;
                    }
                })
                setSubdealerList(updatedList);
            },
            onError: (err) => {
                toast("Cant update subdealer. Please try again", { type: 'error' })
            }
        })
        setisLoading(false)
    }

    if (isLoading) {
        return <div className="spinner-border" role="status">
            <span className="visually-hidden">Loading...</span>
        </div>
    } else
        return <>
            <IoMdPerson /> Admin Subdealer : {subdealer?.user.is_admin_subdealer ? "Yes" : "No"} <br />
            <IoMdLocate /> Assigned Pincodes : {subdealer?.pincodes} <br />
            <IoMdCheckmark /> Is Active : {subdealer?.is_active ? "Yes" : 'No'} | <button
                onClick={() => { setisLoading(true); updateSubdealer({ is_active: !subdealer.is_active }) }}
                className={subdealer?.is_active ? "btn btn-sm btn-danger m-2" : 'btn btn-sm btn-success m-2'}>
                {subdealer?.is_active ? "Dectivate" : 'Activate'}
            </button>
        </>
}
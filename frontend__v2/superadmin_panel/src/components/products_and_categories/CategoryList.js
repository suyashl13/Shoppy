import React, { useContext, useState } from 'react'
import { toast } from 'react-toastify'
import { ProductContext } from '../../contexts/ProductContext'
import { updateCategoryAtBackend } from '../../helpers/BackendProductAndCategoryHelper'

export default function CategoryList({ categories }) {
    return (
        <div className='row'>

            {
                categories?.map((element, index) => <div className="col-sm-12 col-md-6 col-lg-4 mb-3" key={index}>
                    <div className='card border'>
                        <div className="card-header">
                            <center className='fw-bold'>{element?.name}</center>
                        </div>
                        <img src={element?.display_url} className='card-img-top' alt="" />
                        <CategoryActivationButton category={element} />
                    </div></div>)
            }
        </div>
    )
}

const CategoryActivationButton = ({ category }) => {

    const [isLoading, setIsLoading] = useState(false)
    const { productAndCategoryList, setProductAndCategoryList } = useContext(ProductContext)

    const updateCategory = (updateObject) => {
        setIsLoading(true)
        updateCategoryAtBackend(category?.id, updateObject, {
            onSuccess: ({ data }) => {
                const updatedCategories = productAndCategoryList?.categories?.map(e => {
                    if (e.id == category?.id) {
                        return data;
                    } else {
                        return e;
                    }
                })
                setProductAndCategoryList({ ...productAndCategoryList, categories: updatedCategories });
                toast('Category updated successfully.', { type: 'info' })
                setIsLoading(false)
            },
            onError: () => {
                toast('Unable to update category.', { type: 'error' })
                setIsLoading(false)
            }
        })
    }

    return <button
        disabled={isLoading}
        onClick={() => { updateCategory({ is_active: !category?.is_active }) }}
        className={category.is_active ? "btn btn-danger" : 'btn btn-success'}>{
            isLoading ? "Loading" :
            category.is_active ? "Deactivate" : 'Activate'}</button>

}
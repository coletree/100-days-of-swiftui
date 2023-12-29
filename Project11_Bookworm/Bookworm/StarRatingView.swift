//
//  RatingView.swift
//  Bookworm
//
//  Created by coletree on 2023/12/28.
//


/* -------------------------------------------------------------------------------
当构建星级评定组件时，我们创建了一些成为用户交互式控件的东西，像 Button 一样。然而我们并没有停下来考虑它如何与可访问性一起工作，这是一个问题： Button 和其他东西可以很好地工作，但是一旦我们开始创建自己的组件，则需要自己介入并完成这项工作。
 ------------------------------------------------------------------------------- */


import SwiftUI

struct StarRatingView: View {
    
    
    //MARK: - 属性
    @Binding var rating: Int

    var maximumRating = 5
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")
    var offColor = Color.gray
    var onColor = Color.yellow
    
    
    //MARK: - 视图
    var body: some View {
        
        HStack {

            //通过方法1返回的视图
//            HStack(spacing: 4) {
//                ForEach(1..<maximumRating + 1, id: \.self) {
//                    number in
//                    Button {
//                        rating = number
//                        print(rating)
//                    } label: {
//                        image(for: number)
//                            .foregroundStyle(number > rating ? offColor : onColor)
//                    }
//                }
//            }
            
            //通过方法2返回的视图
            RatingStar(for:rating)

        }
        .buttonStyle(.plain)
        
    }
    
    
    //MARK: - 方法
    
    //方法1: 通过函数返回一个个Image
    func image(for number: Int) -> Image {
        if number > rating {
            //offImage ?? onImage
            onImage
        } else {
            onImage
        }
    }

    //方法2: 通过函数返回整个评分星星
    func RatingStar(for number: Int) -> some View {
        HStack(spacing: 2) {
            ForEach(1..<maximumRating + 1, id: \.self) {
                number in
                if number <= rating{
                    Button {
                        rating = number
                    } label: {
                        onImage.foregroundStyle(onColor)
                    }
                }else{
                    Button {
                        rating = number
                    } label: {
                        onImage.foregroundStyle(offColor)
                    }
                }
                
            }
        }
    }


}




#Preview {
    StarRatingView(rating: .constant(4))
}

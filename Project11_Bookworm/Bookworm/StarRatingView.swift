//
//  RatingView.swift
//  Bookworm
//
//  Created by coletree on 2023/12/28.
//


/*
当构建星级评定组件时，我们创建了成为用户交互式控件的东西，像 Button 一样。然而我们并没有停下来考虑它如何与可访问性一起工作，这是一个问题： Button 和其他东西可以很好地工作，但是一旦我们开始创建自己的组件，则需要自己介入并完成这项工作。
 */


import SwiftUI




//星星评分视图
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
        //这里问题是，当表单或列表中有行时，SwiftUI 喜欢假设行本身是可点击的。这使得用户可以更轻松地进行选择，因为他们可以点击行中的任意位置来触发其中的按钮。
        //在这个例子中，由于这一行有多个按钮，因此不管你点击什么位置，SwiftUI 会自动按顺序点击所有按钮，从 1、2、3、4 和 5，所以最终都显示为5。
        //为了解决这个问题，就要加上下面的这一行修饰符 .buttonStyle(.plain)
        .buttonStyle(.plain)
        .accessibilityElement()
        .accessibilityLabel("comment")
        .accessibilityValue(rating == 1 ? "1 star" : "\(rating) stars")
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment:
                if rating < maximumRating { rating += 1 }
            case .decrement:
                if rating > 1 { rating -= 1 }
            default:
                break
            }
        }
        
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



//MARK: - 预览
#Preview {
    StarRatingView(rating: .constant(4))
}

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:idealize_new_version/Core/Components/buttons_widget.dart';
import 'package:idealize_new_version/Core/Components/image_loader_widget.dart';
import 'package:idealize_new_version/Core/Components/textfields_widget.dart';
import 'package:idealize_new_version/Core/Constants/colors.dart';
import 'package:idealize_new_version/Core/Constants/config.dart';
import 'package:idealize_new_version/Core/Constants/icons.dart';
import 'package:idealize_new_version/Core/Constants/routes.dart';
import 'package:idealize_new_version/Core/Data/Models/project_comment_model.dart';
import 'package:idealize_new_version/Core/I18n/messages.dart';
import 'package:idealize_new_version/Core/Utils/extensions.dart';
import 'package:idealize_new_version/app_repo.dart';
import 'package:idealize_new_version/gen/assets.gen.dart';

class CommentContainerWidget extends StatefulWidget {
  final String projectOwner;
  final ProjectComment comment;
  final bool isReply;
  final Function(String id)? onTappedReply;
  final Function(String id)? onTappedRemove;
  final Function(
    String commentId,
    String comment,
    String reportedUser,
    String reason,
  )? onTappedReport;

  const CommentContainerWidget({
    super.key,
    required this.projectOwner,
    required this.comment,
    this.isReply = false,
    this.onTappedReply,
    this.onTappedRemove,
    this.onTappedReport,
  });

  @override
  State<CommentContainerWidget> createState() => _CommentContainerWidgetState();
}

class _CommentContainerWidgetState extends State<CommentContainerWidget> {
  bool _repliesShown = false;
  final reportController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _commentWidget,
        if (widget.comment.replies.$1 > 0 && _repliesShown) _repliesWidget,
        if (widget.comment.replies.$2.isNotEmpty)
          InkWell(
            onTap: () {
              setState(() {
                _repliesShown = !_repliesShown;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0).copyWith(bottom: 10),
              child: Text(
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11.5,
                  color: AppColors().darkGrayColor,
                  fontWeight: FontWeight.w600,
                ),
                _repliesShown
                    ? AppStrings.hideComments.tr
                    : '${AppStrings.showComments.tr} (${widget.comment.replies.$1})',
              ),
            ),
          ),
      ],
    );
  }

  Widget get _repliesWidget => Container(
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade100.withOpacity(0.2),
          border: Border.all(
            color: AppColors().lightGrayColor.withOpacity(0.4),
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          children: widget.comment.replies.$2.map((reply) {
            return Column(
              children: [
                CommentContainerWidget(
                  projectOwner: widget.projectOwner,
                  comment: reply,
                  isReply: true,
                  onTappedReply: widget.onTappedReply,
                  onTappedRemove: widget.onTappedRemove,
                ),
                if (reply != widget.comment.replies.$2.last)
                  Divider(
                    color: AppColors().lightGrayColor,
                    thickness: 0.2,
                  ),
              ],
            );
          }).toList(),
        ),
      );

  Widget get _commentWidget {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            Get.toNamed(
              AppRoutes().userSuggestionProfile,
              arguments: widget.comment.user.id,
            );
          },
          child: (widget.comment.user.profilePicture == null ||
                  widget.comment.user.profilePicture!.id.isEmpty)
              ? _placeholderProfile()
              : ClipRRect(
                  borderRadius: BorderRadius.circular(38),
                  child: showImageFromNetwork(
                    widget.comment.user.profilePicture!.id,
                    height: 38,
                    width: 38,
                    placeholder: _placeholderProfile(),
                  ),
                ),
        ),
        Gap(AppConfig().dimens.small),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _commentHeader(),
              Gap(AppConfig().dimens.small),
              _commentContent(),
              const Gap(10),
              _replyButton(),
            ],
          ),
        ),
      ],
    ).paddingAll(AppConfig().dimens.small);
  }

  Widget _commentHeader() {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              Get.toNamed(
                AppRoutes().userSuggestionProfile,
                arguments: widget.comment.user.id,
              );
            },
            child: Text(
              '${toCamelCase(widget.comment.user.firstname)} ${toCamelCase(widget.comment.user.surname)}',
              style: TextStyle(
                color: AppColors().txtColor,
                fontWeight: FontWeight.w700,
                fontSize: 12.5,
                letterSpacing: -0.4,
              ),
            ),
          ),
        ),
        Gap(AppConfig().dimens.small),
        Text(
          widget.comment.createdAt.timeAgo(),
          style: TextStyle(color: AppColors().txtColor, fontSize: 12),
        ),
      ],
    );
  }

  Widget _commentContent() {
    return (AppRepo().user!.id == widget.projectOwner ||
            AppRepo().user!.id == widget.comment.user.id)
        ? Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  widget.comment.content,
                  style: const TextStyle(
                    fontSize: 12,
                    letterSpacing: -0.4,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Row(
                  children: [
                    SizedBox(
                      width: 24,
                      child: InkWell(
                        onTap: () {
                          widget.onTappedRemove?.call(widget.comment.id);
                        },
                        child: Icon(
                          Icons.delete,
                          color: AppColors().lightGrayColor,
                          size: 18,
                        ),
                      ),
                    ),
                    Gap(AppConfig().dimens.small),
                    SizedBox(
                      width: 24,
                      child: InkWell(
                        onTap: () {
                          _showReportDialog(context, widget.comment.id);
                        },
                        child: Icon(
                          Icons.report,
                          color: AppColors().lightGrayColor,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  widget.comment.content,
                  style: const TextStyle(
                    fontSize: 12,
                    letterSpacing: -0.4,
                  ),
                ),
              ),
              SizedBox(
                width: 24,
                child: InkWell(
                  onTap: () {
                    _showReportDialog(context, widget.comment.id);
                  },
                  child: Icon(
                    Icons.report,
                    color: AppColors().lightGrayColor,
                    size: 18,
                  ),
                ),
              ),
            ],
          );
  }

  void _showReportDialog(BuildContext context, String commentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppStrings.report.tr),
          content: Text(AppStrings.commentReportReason.tr),
          actions: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("${AppStrings.reason.tr}:",
                    style: TextStyle(
                      color: AppConfig().colors.txtColor,
                      fontWeight: FontWeight.w700,
                    )),
                Gap(AppConfig().dimens.small),
                CustomMultiLineTextField(
                  labelText: AppStrings.enterYourReason.tr,
                  controller: reportController,
                  maxCharcters: 300,
                  maxLines: 7,
                ),
              ],
            ),
            // Gap(AppConfig().dimens.medium),
            CustomIconButton(
                    title: AppStrings.report.tr,
                    onTap: () {
                      widget.onTappedReport?.call(
                        commentId,
                        widget.comment.content,
                        widget.comment.user.id,
                        reportController.text,
                      );
                    },
                    txtColor: AppConfig().colors.primaryColor)
                .paddingOnly(top: 20),
          ],
        );
      },
    );
  }

  Widget _replyButton() {
    return InkWell(
      onTap: () => widget.onTappedReply?.call(widget.comment.id),
      child: Row(
        children: [
          Icon(
            Iconsax.messages_3,
            size: 18,
            color: AppColors().darkGrayColor,
          ),
          Gap(AppConfig().dimens.small),
          Text(
            AppStrings.reply.tr,
            style: TextStyle(
              color: AppColors().darkGrayColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholderProfile() {
    return Container(
      height: 38,
      width: 38,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppConfig().colors.lightGrayColor,
          width: 1,
        ),
        shape: BoxShape.circle,
        image: DecorationImage(
          image: AssetImage(Assets.png.placeholderProfile.path),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

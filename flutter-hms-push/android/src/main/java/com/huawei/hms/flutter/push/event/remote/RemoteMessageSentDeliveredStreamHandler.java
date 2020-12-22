/*
    Copyright 2020. Huawei Technologies Co., Ltd. All rights reserved.

    Licensed under the Apache License, Version 2.0 (the "License")
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        https://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
*/

package com.huawei.hms.flutter.push.event.remote;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.IntentFilter;

import androidx.localbroadcastmanager.content.LocalBroadcastManager;

import com.huawei.hms.flutter.push.constants.PushIntent;
import com.huawei.hms.flutter.push.receiver.remote.RemoteMessageSentDeliveredReceiver;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.EventChannel.StreamHandler;

public class RemoteMessageSentDeliveredStreamHandler implements StreamHandler {
    private Context context;
    private BroadcastReceiver remoteMsgSentDeliveredEventBroadcastListener;

    public RemoteMessageSentDeliveredStreamHandler(Context ctx) {
        this.context = ctx;
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        remoteMsgSentDeliveredEventBroadcastListener = createRemoteMessageEventBroadcastReceiver(events);
        // context.registerReceiver(remoteMsgSentDeliveredEventBroadcastListener,
        //         new IntentFilter(PushIntent.REMOTE_MESSAGE_SENT_DELIVERED_ACTION.id()));
        LocalBroadcastManager.getInstance(context).registerReceiver(remoteMsgSentDeliveredEventBroadcastListener,
        new IntentFilter(PushIntent.TOKEN_INTENT_ACTION.id()));
    }

    @Override
    public void onCancel(Object arguments) {
        // context.unregisterReceiver(remoteMsgSentDeliveredEventBroadcastListener);
        LocalBroadcastManager.getInstance(context).unregisterReceiver(remoteMsgSentDeliveredEventBroadcastListener);
    }

    private BroadcastReceiver createRemoteMessageEventBroadcastReceiver(final EventChannel.EventSink events) {
        return new RemoteMessageSentDeliveredReceiver(events);
    }

}
